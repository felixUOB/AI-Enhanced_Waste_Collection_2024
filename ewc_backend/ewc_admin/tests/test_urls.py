# from django.test import TestCase
# from django.urls import reverse, resolve
# from ewc_web.views import UserProfileViewSet, CollectionPointViewSet, JourneyMetricViewSet, WastePredictionViewSet
#
#
# class UrlTests(TestCase):
#
#     def test_user_profile_url_is_resolved(self):
#         url = reverse('userprofile-list')
#         self.assertEqual(resolve(url).func.cls, UserProfileViewSet)
#
#     def test_collection_point_url_is_resolved(self):
#         url = reverse('collectionpoint-list')
#         self.assertEqual(resolve(url).func.cls, CollectionPointViewSet)
#
#     def test_journey_metric_url_is_resolved(self):
#         url = reverse('journeymetric-list')
#         self.assertEqual(resolve(url).func.cls, JourneyMetricViewSet)
#
#     def test_waste_prediction_url_is_resolved(self):
#         url = reverse('wasteprediction-list')
#         self.assertEqual(resolve(url).func.cls, WastePredictionViewSet)