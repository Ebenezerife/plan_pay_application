# plan_pay_application

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

// THIS REMINDS CHATGPT OF WHERE WE STOPPED
Project: Flutter Plan Pay App

Progress so far:
- We have **MonthlyPlanView** and **WeeklyPlanView**.
- **Monthly plan**:
  - Amount input is now **comma-safe** (e.g., 5,000 works correctly).
  - Monthly payment calculation works correctly.
  - Start month dropdown resets after creating a plan.
  - Uses GetX for state management.
- **Weekly plan**:
  - Fully working with weekly payment calculation.
  - Amount and number of weeks inputs work correctly.
- Wallet checks implemented for both weekly and monthly plans.
- Clear form functionality is implemented.

Files involved:
- `monthly_view_model.dart`
- `monthly_plan_view.dart`
- `weekly_view_model.dart`
- `weekly_plan_view.dart`
- `wallet_view_model.dart`

Next tasks / focus areas:
- [Your next task here, e.g., "Add edit/delete plan feature", "Improve UI", "Add TransactionHistory"]
