import logging
import sys

from .gtk_app import ConverterApp


def main() -> int:
    logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
    return ConverterApp().run(sys.argv)


if __name__ == "__main__":
    sys.exit(main())