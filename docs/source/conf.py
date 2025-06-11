# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

import sys
from pathlib import Path

sys.path.append(str(Path("_ext").resolve()))


project = "Prism"
copyright = "2025, Matthew Blanchard, LJNIC"
author = "Matthew Blanchard, LJNIC"

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    "sphinx_lua_ls",
    "sphinx_copybutton",
    "sphinxcontrib.video",
    "atsphinx.goto_top",
    "sphinx_design",
    "timeline",
]

lua_ls_project_root = "../../"

templates_path = ["_templates"]
exclude_patterns = []

root_doc = "index"

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = "alabaster"
html_static_path = ["_static"]
html_css_files = ["terminal.css"]

html_sidebars = {
    "**": [
        "about.html",
        "readingmodes.html",
        "searchfield.html",
        "navigation.html",
        "relations.html",
        "donate.html",
    ]
}

html_theme_options = {
    "github_user": "prismrl",
    "github_repo": "prism",
    "logo": "prism.png",
    "sidebar_width": "244px",
}

html_favicon = "_static/prism.png"

pygments_style = "pastie"
