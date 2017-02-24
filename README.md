Spree Mercado Pago Payment Method
=================================

This project is compatible with spree 3.2.0 and Rails 5

```
gem 'spree_mercado_pago', '~> 3.2.0.rc2', git: "git@github.com:manuca/spree_mercado_pago.git"
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
- Execute `bundle`
- Execute `rake test_app` to build a dummy app directory inside specs
- Execute `bundle exec rspec spec`
