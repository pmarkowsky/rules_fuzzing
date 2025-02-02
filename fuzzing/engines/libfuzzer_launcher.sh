# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# The command line arguments for launching fuzz tests linked with the
# libFuzzer engine. The launch configuration is supplied by the launcher
# script through environment variables.

command_line=("$(readlink -f ${FUZZER_BINARY})")

# libFuzzer flags.

if [[ -n "${FUZZER_DICTIONARY_PATH}" ]]; then
    command_line+=("-dict=${FUZZER_DICTIONARY_PATH}")
fi
command_line+=("-artifact_prefix=${FUZZER_ARTIFACTS_DIR}/")
if [[ "${FUZZER_TIMEOUT_SECS}" -gt 0 ]]; then
    command_line+=("-max_total_time=${FUZZER_TIMEOUT_SECS}")
fi
if (( FUZZER_IS_REGRESSION )); then
    command_line+=("-runs=0")
else
    command_line+=("${FUZZER_OUTPUT_CORPUS_DIR}")
fi

# Corpus sources.

if [[ -n "${FUZZER_SEED_CORPUS_DIR}" ]]; then
    command_line+=("${FUZZER_SEED_CORPUS_DIR}")
fi

exec "${command_line[@]}" "$@"
