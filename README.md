### MayakGenerator

MayakGenerator - set of custom generators fot ruby on rails template
[Mayak](https://github.com/dymio/mayak).

#### How to install

add this code to your Gemfile
``` ruby
'gem "mayak_generator", git: "git@github.com:dissident/mayak_generator.git"'
```

#### How to use

``` ruby
rails g mayak:model_only Product name body:text preview:image
rails g mayak:admin_only Product name body:text preview:image
```

available fields:

- string
- image
- text
- belongs_to
- has_many
- seo

#### how to contribute (specialy for Pablo Escobar)

- fork this repository
- create changes
- pull request me your changes

This project rocks and uses MIT-LICENSE.
