import { Component, inject } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-admin-users',
  standalone: true,
  imports: [],
  templateUrl: './admin-dashboard.component.html',
  styleUrl: './admin-dashboard.component.scss',
})
export class AdminDashboardComponent {
  private router = inject(Router);

  goToUsers() {
    this.router.navigate(['/admin/users']);
  }

  goToReservations() {
    this.router.navigate(['/admin/reservations']);
  }
}
