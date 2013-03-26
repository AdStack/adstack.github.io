# AdStack Public Site

This is the full source for the public-facing site of AdStack.

## System Requirements
- **ruby**: download ruby from [ruby-lang.org/en/downloads/](http://www.ruby-lang.org/en/downloads/)
- **jekyll**: after installing ruby, run: `gem install jekyll`
- **node.js**: download from [nodejs.org/download/](http://nodejs.org/download/)
- **grunt-cli**: after installing node.js, run as a super-user: `npm install -g grunt-cli`

## Instant Setup

Assuming you have met all of the system requirements:

```
npm install && grunt && jekyll --server
```

Then point your browser to `localhost:4000`.

### Build Process and Development

While developing, use `grunt watch` to let grunt automagically compile production assets when files change. Production assets go in the `dist` folder.

### Styles and Layout

The layout uses a custom grid system that is loosely based on Twitter Bootstrap's 12-column grid.