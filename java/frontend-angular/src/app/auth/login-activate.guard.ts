import {CanActivateFn, Router} from '@angular/router';
import {inject} from "@angular/core";
import {AuthenticationService} from "../authentication.service";
import {map} from "rxjs";

export const loginActivateGuard: CanActivateFn = (route, state) => {
  const authenticationService = inject(AuthenticationService);
  const router = inject(Router);
  return authenticationService.isLoggedIn
    .pipe(
      map(isLoggedIn => {
        if (!isLoggedIn) {
          return router.createUrlTree(['authentication']);
        }
        return true;
      })
    )
};
