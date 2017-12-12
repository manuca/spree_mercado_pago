Solidus Mercado Pago Payment Method. WORK IN PROGRESS
=================================

This project is a working progress. It is a fork from the [spree version maintained by manuca](https://github.com/manuca/spree_mercado_pago), which is compatible with spree 3.2.0 and Rails 5.


```
gem 'solidus_mercado_pago', git: "git@github.com:ngelx/solidus_mercado_pago.git"
```

You should run inside your project

```
bundle exec rails g spree_mercado_pago:install
```

This will import assets and migrations

Usage
-----

- Add a new payment method in the admin panel of type Spree::PaymentMethod::MercadoPago
- After adding the payment method you will be able to configure your Client ID and Client Secret (provided by Mercado Pago).

IPN
---

For IPN you need to configure the notification URL in Mercado Pago's site. The notification URL will be `http[s]://[your_domain]/mercado_pago/ipn`. Please review Mercado Pago's documentation at http://developers.mercadopago.com/ for the correct place where to configure IPN notification URLs.


Testing
-------

- Clone this repo
- `ln -s docker-compose-{platform}.yml docker-compose.yml`
- `docker-sync start` **Only in mac**
- `docker-compose up`
- `docker-compose run web bundle exec rake test_app` to build a dummy app directory inside specs
- `docker-compose run web bundle exec rspec spec`
