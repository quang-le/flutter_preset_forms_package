# preset_form_fields

TextFormField with validators and input formatters for common fields

## Use

- First name : Field.firstName
- Last name: Field.lastName
- Company name: Field.companyName
- Date: Field.date
- Address: Field.address
- Email: Field.email
- Country: Field.country
- Phone Number: PhoneFormField widget

Each field has a default input formatter and validator. They can be overridden using the `inputFormatter` and `validator fields respectively` In the case of `Field.date`, you need to use `Custom.dateValidator`to wrap your validation function.
Dates use the dd/mm/yyyy format by default. To use mm/dd/yyyy set the `dateFormat` field in `Field.date` to `DateFormat.us`.

There is also a `Field.textForm`, which is just a TextFormField. I just implemented it for the sake of name consistency.
I first developed this package as an app on [this repo](https://github.com/quang-le/flutter_form_validation), you can find more dev notes over there.

## To do before release

[X] Create example app

[] Create unit tests

[X] Fix DropDownList screen location

[X] Update date error messages
[X] Align flags and country codes in phone field

## Credits

PhoneFormField widget adapted from InternationalPhoneInput from [international_phone_input package](https://pub.dev/packages/international_phone_input), which I contributed to. 

As Flutter doesn't allow setting DropDownList height yet, I'm using [this solution](https://gist.github.com/tudor07/9f886102f3cb2f69314e159ea10572e1) from [tudor07](https://stackoverflow.com/users/3979172/tudorprodan), with a very minor tweak.

regexp for email format validation taken from [validators package](https://pub.dev/packages/validators)

## Contributions

Comments and contributions are welcome. Please create an issue or a PR, I'll get in touch.

