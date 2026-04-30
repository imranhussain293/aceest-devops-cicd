import sys
from pathlib import Path


def pytest_sessionstart(session):
    repo_root = Path(__file__).resolve().parents[1]
    src_path = repo_root / "src"
    sys.path.insert(0, str(src_path))
