export interface AdminUsersFilters {
  group: string;
  personal_data: string;
}

export interface AdminUsersItem {
  identifier: string;
  email: string;
  profile: {
    first_name: string;
    last_name: string;
    phone_number: string;
    avatar: string;
    id_card: string;
  };
  groups: [
    {
      id: number;
      name: string;
    },
  ];
  is_superuser: boolean;
  is_active: boolean;
}
