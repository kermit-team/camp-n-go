export interface RegisterRequest {
  email: string;
  password: string;
  profile: ProfileRequest;
}

export interface ProfileRequest {
  first_name: string;
  last_name: string;
}
