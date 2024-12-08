export interface ErrorMessage {
  error: string;
  message: string;
}

export const errorMessages: ErrorMessage[] = [
  { error: 'email', message: 'Błedny email' },
  { error: 'differentPassword', message: 'Hasła nie są identyczne' },
  {
    error: 'passwordMinLength',
    message: 'Hasło musi mieć co najmniej 9 znaków',
  },
  {
    error: 'pattern',
    message:
      'Hasło musi mieć co najmniej 1 dużą literę, 1 znak specjalny i jedną cyfrę',
  },
  { error: 'required', message: 'Pole niezbędne' },
  { error: 'passwordsMismatch', message: 'Hasła nie zgadzają się' },
];
