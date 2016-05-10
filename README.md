### MayakGenerator

MayakGenerator - set of custom generators fot ruby on rails template
[Mayak](https://github.com/dymio/mayak).

#### How to install

add this code to your Gemfile

``` ruby
gem "mayak_generator", github: "dissident/mayak_generator", group: "development"
```

#### How to use

``` ruby
rails g mayak:model Product name body:text preview:image
rails g mayak:admin Product name body:text preview:image
rails g mayak:m2m product category
```

available fields:

- string
- image
- text
- belongs_to
- has_many
- seo

#### how to reset changes by git

If you do not got what he wanted, after generation, most effective
 variant - git reset all your changes.

``` ruby
git reset --hard
git clean -f -d
```

#### how to contribute (specialy for Pablo Escobar)

- fork this repository
- create changes
- pull request me your changes

This project rocks and uses MIT-LICENSE.
