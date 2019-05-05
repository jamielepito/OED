/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
 
CREATE TABLE buildingGroups(
    -- foreign key to building
    FOREIGN KEY (buildingID) REFERENCES buildings (buildingID)
    -- foreign key to group
    FOREIGN KEY (parent_id, child_id) REFERENCES groups (parent_id, child_id)
    -- primary key is unique combination of these 2 
    PRIMARY KEY buildingGroupID (buildingID,parent_id, child_id)

)