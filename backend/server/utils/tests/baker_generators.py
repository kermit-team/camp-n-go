import random

from phonenumber_field.phonenumber import PhoneNumber


def generate_phone_number() -> str:
    first_phone_number_digit = str(
        random.choice(
            [
                45,
                50,
                51,
                53,
                57,
                60,
                66,
                69,
                72,
                73,
                78,
                79,
                88,
            ],
        ),
    )
    phone_number_digits = [str(random.randint(0, 9)) for _ in range(7)]
    phone_number_digits.insert(0, first_phone_number_digit)

    phone_number = PhoneNumber.from_string(phone_number=''.join(phone_number_digits), region='PL')
    return str(phone_number)
