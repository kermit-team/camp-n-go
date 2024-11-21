import { Component, Input } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { NgClass, NgIf, NgOptimizedImage, NgStyle } from '@angular/common';

@Component({
  selector: 'lib-button',
  standalone: true,
  imports: [
    RouterLink,
    NgIf,
    ReactiveFormsModule,
    NgClass,
    NgOptimizedImage,
    FormsModule,
    NgStyle,
  ],
  templateUrl: './button.component.html',
  styleUrl: './button.component.scss',
})
export class ButtonComponent {
  @Input() fullWidth = false;
}
