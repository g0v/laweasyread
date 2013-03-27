name: \laweasyread
version: \0.0.1
descritpion: 'API for Taiwan law'
scripts:
  prepublish: """
    ./node_modules/.bin/lsc -cj package.ls
    ./node_modules/.bin/lsc -co lib lib/*.ls
    ./node_modules/.bin/lsc -c app.ls
  """
  test: """
    ./node_modules/.bin/lsc test/*.ls
  """
dependencies:
  express: \3.x
  \romanize-component : \0.1.x
engines:
  node: \0.10.x
devDependencies:
  LiveScript: \1.1.x
  should: \1.2.x
license: \MIT
