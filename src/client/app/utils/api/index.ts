/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

import ApiBackend from './ApiBackend';
import GroupsApi from './GroupsApi';
import MetersApi from './MetersApi';
import FileProcessingApi from './FileProcessingApi';
import PreferencesApi from './PreferencesApi';
import VerificationApi from './VerificationApi';
import CompressedReadingsApi from './CompressedReadingsApi';

const apiBackend = new ApiBackend();

// All specific backends share the same ApiBackend
const groupsApi = new GroupsApi(apiBackend);
const metersApi = new MetersApi(apiBackend);
const fileProcessingApi = new FileProcessingApi(apiBackend);
const preferencesApi = new PreferencesApi(apiBackend);
const verificationApi = new VerificationApi(apiBackend);
const compressedReadingsApi = new CompressedReadingsApi(apiBackend);

export { groupsApi, metersApi, fileProcessingApi, preferencesApi, verificationApi, compressedReadingsApi };
