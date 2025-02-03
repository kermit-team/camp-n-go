export interface AdminReservationItem {
  id: number;
  date_from: string;
  date_to: string;
  user: {
    identifier: string;
    profile: {
      first_name: string;
      last_name: string;
    };
  };
  car: {
    id: number;
    registration_plate: string;
  };
  payment: {
    id: number;
    status: number;
    price: string;
  };
}

export interface AdminReservationFilters {
  reservation_data: string;
  date_from: string;
  date_to: string;
}
