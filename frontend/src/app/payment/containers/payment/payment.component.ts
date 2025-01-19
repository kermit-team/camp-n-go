import { Component, inject } from '@angular/core';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { ButtonComponent } from '../../../shared/components/button/button.component';

@Component({
  selector: 'app-reservation-create',
  standalone: true,
  templateUrl: './payment.component.html',
  styleUrl: './payment.component.scss',
  imports: [ButtonComponent, RouterLink],
})
export class PaymentComponent {
  private route = inject(ActivatedRoute);

  isPaymentSuccessful = this.route.snapshot.url
    .map((segment) => segment.path)
    .pop();
}
