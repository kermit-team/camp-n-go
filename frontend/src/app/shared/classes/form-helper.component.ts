import { Component, inject } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';

@Component({
  template: ``,
})
export abstract class FormHelperComponent {
  form: FormGroup;

  protected fb = inject(FormBuilder);

  controlHasError(controlName: string) {
    return (
      this.form.get(controlName).invalid && this.form.get(controlName).touched
    );
  }

  customControlHasError(controlName: string, formControlName: string) {
    return (
      this.form.get(formControlName).get(controlName).invalid &&
      this.form.get(formControlName).get(controlName).touched
    );
  }
}
