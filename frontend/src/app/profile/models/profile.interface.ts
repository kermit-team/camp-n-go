export interface ProfileEdit {
  old_password?: string;
  new_password?: string;
  profile: {
    first_name: string;
    last_name: string;
    phone_number: string;
    avatar: string;
    id_card: string;
  };
}

export interface PasswordEdit {
  old_password: string;
  new_password: string;
}
