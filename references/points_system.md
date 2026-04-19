# Points Sharing System & Biblical Mapping

This document explains how points are tracked and distributed within the `superskill-biblical-collaboration` framework.

## The Principle of Shared Harvest

"A generous person will prosper; whoever refreshes others will be refreshed." (Proverbs 11:25)

In this superskill, no individual collaborator keeps all the points (rewards) for a task. Instead, points are shared equally among all participants who contributed to the goal.

### Point Calculation

1. **Task Value:** Every task is assigned a total point value (default: 100 points).
2. **Distribution:** The total points are divided by the number of enrolled collaborators.
3. **Allocation:** Each collaborator receives an equal share of the points upon task completion.

### Example Scenario

- **Task:** Build a fully automated e-commerce store with AI-generated content and a promotional video.
- **Collaborators Enrolled:** 4 (Visionary, Builder, Organizer, Encourager)
- **Total Points:** 100
- **Distribution:** 100 / 4 = 25 points per collaborator.

### Tracking and Transparency

The `orchestrate_collaboration.py` script maintains a transparent ledger of all points awarded to each collaborator. This ensures fairness and accountability across the team.
