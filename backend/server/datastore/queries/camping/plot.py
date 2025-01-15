from datetime import date
from typing import Optional

from django.db.models import QuerySet, Subquery

from server.apps.camping.models import CampingPlot, PaymentStatus, Reservation


class CampingPlotQuery:
    unavailability_payment_statuses = [
        PaymentStatus.WAITING_FOR_PAYMENT,
        PaymentStatus.PAID,
    ]

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

        unavailable_camping_plot_ids = Reservation.objects.filter(
            date_from__lt=date_to,
            date_to__gt=date_from,
            payment__status__in=cls.unavailability_payment_statuses,
        ).values_list('camping_plot', flat=True).distinct()

        return queryset.filter(
            max_number_of_people__gte=number_of_people,
        ).exclude(
            id__in=Subquery(unavailable_camping_plot_ids),
        ).order_by('id')
