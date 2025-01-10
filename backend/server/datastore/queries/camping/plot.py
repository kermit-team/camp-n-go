from datetime import date
from typing import Optional

from django.db.models import Q, QuerySet

from server.apps.camping.models import CampingPlot, PaymentStatus


class CampingPlotQuery:
    @classmethod
    def get_available(
        cls,
        number_of_people: int,
        date_from: date,
        date_to: date,
        queryset: Optional[QuerySet] = None,
    ) -> QuerySet:
        if queryset is None:
            queryset = CampingPlot.objects.all()

        return queryset.filter(
            Q(
                reservations__date_from__lt=date_to,
                reservations__date_to__gt=date_from,
                reservations__payment__status=PaymentStatus.CANCELED,
            ) |
            ~Q(
                reservations__date_from__lt=date_to,
                reservations__date_to__gt=date_from,
            ),
            max_number_of_people__gte=number_of_people,
        ).order_by('id')
