import random
import string

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


def generate_password() -> str:
    special_characters = r'()[\]{}|\\`~!@#$%^&*_\-+=;:\'",<>./?'
    digits = string.digits
    lowercase = string.ascii_lowercase
    uppercase = string.ascii_uppercase
    all_characters = special_characters + digits + lowercase + uppercase

    required_chars = [
        random.choice(special_characters),
        random.choice(digits),
        random.choice(lowercase),
        random.choice(uppercase)
    ]

    required_chars.extend(random.choices(all_characters, k=5))

    random.shuffle(required_chars)

    return ''.join(required_chars)
