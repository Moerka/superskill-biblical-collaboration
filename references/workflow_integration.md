# Workflow Integration

This document details how the `superskill-biblical-collaboration` integrates all other available skills into a unified workflow.

## The Body of Christ Model (1 Corinthians 12:12-27)

Just as the body has many parts, each skill serves a unique function within the superskill:

1. **The Visionary (Prophet)**
   - **Skills Used:** `internet-skill-finder`, `similarweb-analytics`, `stock-analysis`
   - **Function:** Gathers insights, analyzes the environment, and provides direction for the task.

2. **The Builder (Craftsman)**
   - **Skills Used:** `master-automation-engine`, `github-gem-seeker`
   - **Function:** Constructs the solution, writes the code, and builds the automation framework.

3. **The Organizer (Administrator)**
   - **Skills Used:** `excel-generator`, `gws-best-practices`
   - **Function:** Structures the data, organizes the output, and ensures the results are clear and actionable.

4. **The Encourager (Exhorter)**
   - **Skills Used:** `bgm-prompter`, `video-generator`
   - **Function:** Creates engaging media, produces the final presentation, and communicates the message effectively.

## Orchestration Flow

1. **Initialization:** The `orchestrate_collaboration.py` script is called.
2. **Assignment:** Based on the task description, the engine identifies which "parts of the body" (skills) are required.
3. **Execution:** The assigned collaborators use their respective skills to complete their portion of the task.
4. **Integration:** The outputs from the various skills are combined into a final deliverable.
