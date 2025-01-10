from django.conf import settings
from django.conf.urls.static import static
from django.urls import include, path
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView

urlpatterns = [
    path('api/accounts/', include('server.apps.account.urls')),
    path('api/camping/', include('server.apps.camping.urls')),
    path('api/cars/', include('server.apps.car.urls')),
]

if settings.DRF_SPECTACULAR_ON:
    urlpatterns += [
        path('api/schema/', SpectacularAPIView.as_view(), name='schema'),
        path('api/schema/swagger-ui/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger-ui'),
    ]

if settings.DJANGO_SILK_ON:
    urlpatterns += [path('silk/', include('silk.urls', namespace='silk'))]

urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
