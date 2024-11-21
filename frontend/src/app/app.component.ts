import { Component, inject, OnInit } from '@angular/core';
import {
  ActivatedRoute,
  NavigationEnd,
  Router,
  RouterOutlet,
} from '@angular/router';
import { NavbarComponent } from './shared/navbar/navbar.component';
import { FormBuilder } from '@angular/forms';
import { filter } from 'rxjs';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, NavbarComponent],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss',
})
export class AppComponent implements OnInit {
  private router = inject(Router);
  showNavbar = true;

  ngOnInit() {
    this.router.events
      .pipe(filter((event) => event instanceof NavigationEnd))
      .subscribe((event: any) => {
        const hiddenRoutes = ['/register', '/login', '/forgot-password'];
        this.showNavbar = !hiddenRoutes.includes(event.url);
      });
  }

  title = 'camping';
}
