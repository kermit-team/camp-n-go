import {
  APP_INITIALIZER,
  ApplicationConfig,
  provideZoneChangeDetection,
} from '@angular/core';
import { provideRouter } from '@angular/router';

import { routes } from './app.routes';
import { provideHttpClient, withInterceptors } from '@angular/common/http';
import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';
import { tokenInterceptor } from './auth/interceptors/token.interceptor';
import { AppInitializerService } from './app-initializer.service';
import 'moment/locale/pl.js';
import { MAT_DATE_LOCALE, MatDateFormats } from '@angular/material/core';
import { provideMomentDateAdapter } from '@angular/material-moment-adapter';

export const CUSTOM_DATE_FORMATS: MatDateFormats = {
  parse: {
    dateInput: 'DD.MM.YYYY',
  },
  display: {
    dateInput: 'ddd. D MMM.', // Custom format (e.g., 'sob. 9 wrz.')
    monthYearLabel: 'MMM YYYY',
    dateA11yLabel: 'LL',
    monthYearA11yLabel: 'MMMM YYYY',
  },
};

export const appConfig: ApplicationConfig = {
  providers: [
    provideZoneChangeDetection({ eventCoalescing: true }),
    provideRouter(routes),
    provideHttpClient(withInterceptors([tokenInterceptor])),
    provideAnimationsAsync(),
    { provide: MAT_DATE_LOCALE, useValue: 'pl' },
    provideMomentDateAdapter(CUSTOM_DATE_FORMATS),
    {
      provide: APP_INITIALIZER,
      useFactory: (appInitializer: AppInitializerService) => () =>
        appInitializer.initializeApp(),
      deps: [AppInitializerService],
      multi: true,
    },
  ],
};
