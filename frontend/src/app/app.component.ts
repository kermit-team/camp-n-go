import { Component, inject, OnInit } from '@angular/core';
import { NavigationEnd, Router, RouterOutlet } from '@angular/router';
import { NavbarComponent } from './shared/navbar/navbar.component';
import { BehaviorSubject, filter } from 'rxjs';
import { AuthFacade } from './auth/services/auth.facade';
import { AsyncPipe } from '@angular/common';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, NavbarComponent, AsyncPipe],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss',
})
export class AppComponent implements OnInit {
  private router = inject(Router);
  private authFacade = inject(AuthFacade);

  authenticated = this.authFacade.selectAuthenticated$();
  showNavbar = true;
  isBlackNavbar = new BehaviorSubject(true);

  ngOnInit() {
    this.router.events
      .pipe(filter((event) => event instanceof NavigationEnd))
      .subscribe((event: any) => {
        const hiddenRoutes = ['/register', '/login', 'forgot-password'];

        if (event.url === '/') {
          this.isBlackNavbar.next(false);
        } else {
          this.isBlackNavbar.next(true);
        }

        // Dynamic patterns
        const dynamicPatterns = [
          /^\/accounts\/[^/]+$/, // Matches /accounts/{random-token}
          /^\/accounts\/email-verification\/[^/]+\/[^/]+$/, // Matches /accounts/email-verification/{token}/{another-token}
          /^\/accounts\/password-reset\/confirm\/[^/]+\/[^/]+$/, // Matches /accounts/password-reset/confirm
        ];

        // Check if the current route matches any hidden route or dynamic pattern
        this.showNavbar = !(
          hiddenRoutes.includes(event.url) ||
          dynamicPatterns.some((pattern) => pattern.test(event.url))
        );
      });
  }

  title = 'camping';
}
