#!/usr/bin/env python3


try:
    import argparse
    import sys
    from pathlib import Path
    from typing import List, Literal

    from pypdf import PdfWriter
except Exception as e:
    print(f"Oops (import): {e}")
    raise SystemExit(1)


def next_available_output_path(path: Path) -> Path:
    if not path.exists():
        return path

    suffixes = "".join(path.suffixes)
    base_name = path.name[: -len(suffixes)] if suffixes else path.name

    count = 1
    while True:
        candidate = path.with_name(f"{base_name}({count}){suffixes}")
        if not candidate.exists():
            return candidate
        count += 1


def combine_pdfs(
    pdf_paths: List[Path],
    output_path: Path,
    keep_duplicates: bool = False,
    sort_by: Literal["name", "time"] | None = None,
) -> None:

    pdf_paths = [p for p in pdf_paths if p.exists() and p.suffix == ".pdf"]

    if not keep_duplicates:
        seen = set()
        unique_paths: List[Path] = []
        for p in pdf_paths:
            key = str(p.resolve())
            if key in seen:
                continue
            seen.add(key)
            unique_paths.append(p)
        pdf_paths = unique_paths

    if sort_by is not None:
        if sort_by == "time":
            pdf_paths = sorted(pdf_paths, key=lambda p: p.stat().st_mtime)
        elif sort_by == "name":
            pdf_paths = sorted(pdf_paths, key=lambda p: p.name.lower())

    print(f"Found {len(pdf_paths)}")

    writer = PdfWriter()
    for idx, pdf_path in enumerate(pdf_paths):
        print(f"({idx+1}/{len(pdf_paths)}) Appending {pdf_path}")
        writer.append(str(pdf_path))

    with output_path.open("wb") as out_file:
        writer.write(out_file)


if __name__ == "__main__":
    try:
        parser = argparse.ArgumentParser(
            description="Combine PDFs from a directory and/or file list."
        )
        parser.add_argument("--input-dir", type=Path, help="Directory containing PDFs")
        parser.add_argument(
            "--input-files",
            type=Path,
            nargs="*",
            default=[],
            help="One or more input PDF files",
        )
        parser.add_argument(
            "--output", "-o", required=True, type=Path, help="Output PDF path"
        )
        parser.add_argument(
            "--keep-duplicates",
            action="store_true",
            help="Keep duplicate pages (default: remove duplicates)",
        )
        parser.add_argument(
            "--sort-by",
            choices=["name", "time"],
            default=None,
            help="Sort input PDFs by name or modification time (default: none)",
        )
        args = parser.parse_args()

        pdf_paths: List[Path] = []

        if args.input_dir:
            pdf_paths.extend(
                sorted(p for p in args.input_dir.glob("*.pdf") if p.is_file())
            )

        pdf_paths.extend(
            p for p in args.input_files if p.is_file() and p.suffix == ".pdf"
        )

        if not pdf_paths:
            raise Exception("No PDF files provided.")

        if args.output.suffix != ".pdf":
            raise Exception(f"Output has invalid suffix. {args.output}")

        output_path = next_available_output_path(args.output)
        if output_path != args.output:
            print(f"Output exists, using: {output_path}", file=sys.stderr)

        combine_pdfs(
            pdf_paths,
            output_path,
            keep_duplicates=args.keep_duplicates,
            sort_by=args.sort_by,
        )
        print(f"Created: {output_path}")

    except Exception as e:
        print(f"Oops: {e}")
        raise SystemExit(1)
