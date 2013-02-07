# AdStack Public Site

This is the full source for the public-facing site of AdStack. 

## Build Process and Development

The site is built with Jekyll to generate static pages from templates and Markdown. Use `jekyll --server` while developing to setup a dev server at `localhost:4000` that watches files as they change. 

Grunt is used to concatenate and minify all JavaScript and compile LESS files. While developing, use `grunt watch` to let grunt automagically compile production assets when files change. 

## Styles and Layout

The layout uses a custom grid system that is loosely based on Twitter Bootstrap's 12-column grid. 