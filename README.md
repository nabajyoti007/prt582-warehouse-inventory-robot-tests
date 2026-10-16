# Warehouse Inventory System - Robot Framework Testing

This repository contains the automated functional tests I created for the Warehouse Inventory Management System as part of my PRT582 project.

The tests were completed from the **Admin user** perspective using **Robot Framework**, **SeleniumLibrary**, and Google Chrome.

The final regression run completed successfully with:

- 41 tests executed
- 41 passed
- 0 failed
- 0 skipped

## What I tested

The automation covers the main Admin functions of the system:

- Login with valid and invalid credentials
- Admin dashboard
- Sidebar navigation
- Product management
- User group management
- User account management
- Sales
- Daily, monthly and date-range sales reports

The CRUD tests cover creating, editing and deleting records where applicable.

## Test files

The main test files are inside the `final_tests` folder:

```text
final_tests/
├── test_login.robot
├── test_dashboard.robot
├── test_navigation.robot
├── test_product_crud.robot
├── test_group_crud.robot
├── test_user_crud.robot
├── test_sales_crud.robot
└── test_sales_reports.robot
