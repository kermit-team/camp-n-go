import { Component, Input } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgClass, NgStyle } from '@angular/common';

@Component({
  selector: 'lib-button',
  standalone: true,
  imports: [ReactiveFormsModule, FormsModule, NgStyle, NgClass],
  templateUrl: './button.component.html',
  styleUrl: './button.component.scss',
})
export class ButtonComponent {
  @Input() fullWidth = false;
  @Input() type: 'primary' | 'secondary' = 'primary';
  @Input() disabled = false;
}
