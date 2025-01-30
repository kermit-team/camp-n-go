import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { AuthUser } from '../../../auth/models/auth.interface';
import { ProfileBaseFormComponent } from '../profile-base-form/profile-base-form.component';
import { PasswordEdit, ProfileEdit } from '../../models/profile.interface';

@Component({
  selector: 'app-profile-content',
  standalone: true,
  imports: [ProfileBaseFormComponent],
  templateUrl: './profile-content.component.html',
  styleUrl: './profile-content.component.scss',
})
export class ProfileContentComponent implements OnInit {
  @Input() user: AuthUser;
  @Output() userChanged = new EventEmitter<ProfileEdit>();

  oldUser: AuthUser;

  ngOnInit() {
    this.oldUser = this.user;
  }

  dataEdited(path: string, newValue: any): void {
    if (this.user.profile.id_card === this.oldUser.profile.id_card) {
      delete this.user.profile.id_card;
    }
    this.setValueByPath(this.user, path, newValue);
    delete this.user.profile.avatar;
    this.userChanged.emit({
      profile: this.user.profile,
    });
  }

  private setValueByPath(obj: any, path: string, value: any): void {
    const keys = path.split('.');
    let current = obj;

    for (let i = 0; i < keys.length - 1; i++) {
      const key = keys[i];
      current = current[key];
    }

    current[keys[keys.length - 1]] = value;
  }

  passwordChanged(data: PasswordEdit) {
    delete this.user.profile.avatar;
    this.userChanged.emit({
      profile: this.user.profile,
      old_password: data.old_password,
      new_password: data.new_password,
    });
  }
}
