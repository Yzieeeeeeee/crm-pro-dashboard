import 'package:equatable/equatable.dart';
import 'package:crm_dashboard_app/features/dashboard/data/dashboard_model.dart';
import 'package:crm_dashboard_app/features/companies/data/company_model.dart';

/// Represents a single item in the unified dashboard feed.
sealed class DashboardFeedItem extends Equatable {
  const DashboardFeedItem();

  @override
  List<Object?> get props => [];
}

/// An activity item in the feed.
class FeedActivityItem extends DashboardFeedItem {
  final Activity activity;
  const FeedActivityItem(this.activity);

  @override
  List<Object?> get props => [activity];
}

/// A meeting item in the feed.
class FeedMeetingItem extends DashboardFeedItem {
  final Meeting meeting;
  const FeedMeetingItem(this.meeting);

  @override
  List<Object?> get props => [meeting];
}

/// A company spotlight item in the feed.
class FeedCompanyItem extends DashboardFeedItem {
  final CompanyModel company;

  const FeedCompanyItem(this.company);

  @override
  List<Object?> get props => [company];
}

/// A section header injected into the feed (e.g. "Earlier Today").
class FeedSectionHeader extends DashboardFeedItem {
  final String title;
  const FeedSectionHeader(this.title);

  @override
  List<Object?> get props => [title];
}
