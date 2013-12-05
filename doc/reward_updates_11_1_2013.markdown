# Reward Updates

- Pull down a dump
- Delete all rewards created before Time.parse("2013-10-31")
- Pull down and unzip images.  Pass image dir into the importer.
- Reimport new rewards, with images and min/max grades
  - First on staging, only for "J.F. Drake"
- Verify various data:
  - type: "Shipped to School" or local rewards
  - price
  - image
  - name
  - description
  - min_grade
  - max_grade
  - store legacy_reward_id and legacy_reward_detail_id in Spree::Properties
