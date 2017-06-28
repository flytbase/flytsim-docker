import sys, os, subprocess

from sphinx.highlighting import lexers
from pygments.lexers.web import PhpLexer


project = u'FlytDocs'
copyright = u'2017, FlytBase Inc'
author = u'FlytBase Dev Team'

master_doc = 'index'
templates_path = ['_templates']
extensions = []
source_suffix = '.rst'
version = '1.2.0'
exclude_patterns = ['_build']

# -- HTML theme settings ------------------------------------------------

html_show_sourcelink = False
html_sidebars = {
    '**': ['globaltoc.html',
           'searchbox.html']
}

import guzzle_sphinx_theme

sys.path.append(os.path.abspath('_extensions/sphinxcontrib'))
on_rtd = os.environ.get('READTHEDOCS', None) == 'True'

extensions.append("guzzle_sphinx_theme")
extensions.append("youtube")
html_theme_path = guzzle_sphinx_theme.html_theme_path()
html_theme = 'guzzle_sphinx_theme'
html_favicon = "_static/FlytLogos/flytFavicon.ico"
html_static_path = ['_static']

# Guzzle theme options (see theme.conf for more information)
html_theme_options = {
    
    # Set the path to a special layout to include for the homepage
    # "index_template": "special_index.html",

    # # Set the name of the project to appear in the left sidebar.
    "project_nav_name": "FlytBase Documentation",

    # # Set your Disqus short name to enable comments
    # "disqus_comments_shortname": "my_disqus_comments_short_name",

    # # Set you GA account ID to enable tracking
    # "google_analytics_account": "my_ga_account",

    # # Path to a touch icon
    "touch_icon": "_static/FlytLogos/apple-icon-144x144",

    # # Specify a base_url used to generate sitemap.xml links. If not
    # # specified, then no sitemap will be built.
    "base_url": "http://docs.flytbase.com",

    # # Allow a separate homepage from the master_doc
    # "homepage": "index",

    # # Allow the project link to be overriden to a custom URL.
    "projectlink": "http://docs.flytbase.com"
}

# If false, no index is generated.
html_use_index = True

if on_rtd:  # only import and set the theme if we're building docs locally
  html_context = {
    'css_files': [
        '_static/rtd_badge.css',
        'https://media.readthedocs.org/css/readthedocs-doc-embed.css',
        '_static/custom.css',
    ],
  }
