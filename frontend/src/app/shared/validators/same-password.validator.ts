import { AbstractControl } from '@angular/forms';

export function passwordsMatchValidator(
  control: AbstractControl,
): { [key: string]: boolean } | null {
  const password = control.get('password')?.value;
  const confirmPassword = control.get('confirmPassword')?.value;
  if (password !== confirmPassword) {
    return { passwordsMismatch: true };
  }
  return null;
}
