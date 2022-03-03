%% Copyright (c) 2020-2021 Exograd SAS.
%%
%% Permission to use, copy, modify, and/or distribute this software for any
%% purpose with or without fee is hereby granted, provided that the above
%% copyright notice and this permission notice appear in all copies.
%%
%% THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
%% WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
%% MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
%% SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
%% WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
%% ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
%% IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

-module(jsv_validator_tests).

-include_lib("eunit/include/eunit.hrl").

validate_any_test_() ->
  [?_assertMatch({ok, _},
                 jsv:validate(null, any)),
   ?_assertMatch({ok, _},
                 jsv:validate(true, any)),
   ?_assertMatch({ok, _},
                 jsv:validate(42, any)),
   ?_assertMatch({ok, _},
                 jsv:validate(3.14, any)),
   ?_assertMatch({ok, _},
                 jsv:validate(<<"foo">>, any)),
   ?_assertMatch({ok, _},
                 jsv:validate([1, 2, 3], any)),
   ?_assertMatch({ok, _},
                 jsv:validate(#{<<"a">> => 1}, any)),
   ?_assertMatch({ok, _},
                 jsv:validate(42, {any, #{value => 42}})),
   ?_assertMatch({ok, _},
                 jsv:validate([1, 2, 3], {any, #{value => [1, 2, 3]}})),
   ?_assertMatch({error, _},
                 jsv:validate(true, {any, #{value => 42}})),
   ?_assertMatch({error, _},
                 jsv:validate([1], {any, #{value => []}}))].

validate_null_test_() ->
  [?_assertMatch({ok, _},
                 jsv:validate(null, null)),
   ?_assertMatch({error, _},
                 jsv:validate(42, null)),
   ?_assertMatch({error, _},
                 jsv:validate([null], null))].

validate_boolean_test_() ->
  [?_assertMatch({ok, _},
                 jsv:validate(true, boolean)),
   ?_assertMatch({ok, _},
                 jsv:validate(false, boolean)),
   ?_assertMatch({error, _},
                 jsv:validate(null, boolean))].

validate_number_test_() ->
  [?_assertMatch({ok, _},
                 jsv:validate(42, number)),
   ?_assertMatch({ok, _},
                 jsv:validate(-1, number)),
   ?_assertMatch({ok, _},
                 jsv:validate(5.0, number)),
   ?_assertMatch({ok, _},
                 jsv:validate(3.14, number)),
   ?_assertMatch({ok, _},
                 jsv:validate(10, {number, #{min => 10}})),
   ?_assertMatch({ok, _},
                 jsv:validate(42, {number, #{min => 10}})),
   ?_assertMatch({ok, _},
                 jsv:validate(10.0, {number, #{min => 10}})),
   ?_assertMatch({ok, _},
                 jsv:validate(10, {number, #{max => 10.5}})),
   ?_assertMatch({ok, _},
                 jsv:validate(10.5, {number, #{max => 10.5}})),
   ?_assertMatch({ok, _},
                 jsv:validate(-1, {number, #{max => 10.5}})),
   ?_assertMatch({ok, _},
                 jsv:validate(4, {number, #{min => 3, max => 5}})),
   ?_assertMatch({ok, _},
                 jsv:validate(3, {number, #{min => 3, max => 5}})),
   ?_assertMatch({ok, _},
                 jsv:validate(5, {number, #{min => 3, max => 5}})),
   ?_assertMatch({error, _},
                 jsv:validate(42, {number, #{min => 100}})),
   ?_assertMatch({error, _},
                 jsv:validate(5, {number, #{max => 0}})),
   ?_assertMatch({error, _},
                 jsv:validate(2, {number, #{min => 3, max => 5}})),
   ?_assertMatch({error, _},
                 jsv:validate(6, {number, #{min => 3, max => 5}}))].

validate_integer_test_() ->
  [?_assertMatch({ok, _},
                 jsv:validate(42, integer)),
   ?_assertMatch({ok, _},
                 jsv:validate(-1, integer)),
   ?_assertMatch({error, _},
                 jsv:validate(3.0, integer)),
   ?_assertMatch({error, _},
                 jsv:validate(3.14, integer)),
   ?_assertMatch({ok, _},
                 jsv:validate(4, {integer, #{min => 3, max => 5}})),
   ?_assertMatch({ok, _},
                 jsv:validate(3, {integer, #{min => 3, max => 5}})),
   ?_assertMatch({ok, _},
                 jsv:validate(5, {integer, #{min => 3, max => 5}})),
   ?_assertMatch({error, _},
                 jsv:validate(2, {integer, #{min => 3, max => 5}})),
   ?_assertMatch({error, _},
                 jsv:validate(6, {integer, #{min => 3, max => 5}})),
   ?_assertMatch({error, _},
                 jsv:validate(42, {integer, #{min => 100}})),
   ?_assertMatch({error, _},
                 jsv:validate(5, {integer, #{max => 0}}))].

validate_string_test_() ->
  [?_assertMatch({ok, <<"">>},
                 jsv:validate(<<"">>, string)),
   ?_assertMatch({ok, <<"foo">>},
                 jsv:validate(<<"foo">>, string)),
   ?_assertMatch({ok, <<"été"/utf8>>},
                 jsv:validate(<<"été"/utf8>>, string)),
   ?_assertMatch({ok, <<"foo">>},
                 jsv:validate(<<"foo">>, {string, #{min_length => 3}})),
   ?_assertMatch({ok, <<"foobar">>},
                 jsv:validate(<<"foobar">>, {string, #{min_length => 3}})),
   ?_assertMatch({error, _},
                 jsv:validate(<<"fo">>,
                              {string, #{min_length => 3}})),
   ?_assertMatch({ok, <<"foo">>},
                 jsv:validate(<<"foo">>, {string, #{max_length => 3}})),
   ?_assertMatch({ok, <<"f">>},
                 jsv:validate(<<"f">>, {string, #{max_length => 3}})),
   ?_assertMatch({error, _},
                 jsv:validate(<<"foobar">>,
                              {string, #{max_length => 3}})),
   ?_assertMatch({ok, <<"">>},
                 jsv:validate(<<"">>, {string, #{prefix => <<"">>}})),
   ?_assertMatch({ok, <<"foo">>},
                 jsv:validate(<<"foo">>, {string, #{prefix => <<"">>}})),
   ?_assertMatch({ok, <<"foo">>},
                 jsv:validate(<<"foo">>, {string, #{prefix => <<"foo">>}})),
   ?_assertMatch({ok, <<"foobar">>},
                 jsv:validate(<<"foobar">>,
                              {string, #{prefix => <<"foo">>}})),
   ?_assertMatch({error, _},
                 jsv:validate(<<"fob">>,
                              {string, #{prefix => <<"foo">>}})),
   ?_assertMatch({error, _},
                 jsv:validate(<<"bar">>,
                              {string, #{prefix => <<"foo">>}})),
   ?_assertMatch({ok, <<"">>},
                 jsv:validate(<<"">>, {string, #{suffix => <<"">>}})),
   ?_assertMatch({ok, <<"bar">>},
                 jsv:validate(<<"bar">>, {string, #{suffix => <<"">>}})),
   ?_assertMatch({ok, <<"bar">>},
                 jsv:validate(<<"bar">>, {string, #{suffix => <<"bar">>}})),
   ?_assertMatch({ok, <<"foobar">>},
                 jsv:validate(<<"foobar">>,
                              {string, #{suffix => <<"bar">>}})),
   ?_assertMatch({error, _},
                 jsv:validate(<<"foo">>,
                              {string, #{suffix => <<"bar">>}})),
   ?_assertMatch({error, _},
                 jsv:validate(<<"aar">>,
                              {string, #{suffix => <<"bar">>}})),
   ?_assertMatch({ok, foo},
                 jsv:validate(<<"foo">>,
                              {string, #{values => [foo]}})),
   ?_assertMatch({ok, foo},
                 jsv:validate(<<"foo">>,
                              {string, #{values => [foo, bar]}})),
   ?_assertMatch({error, _},
                 jsv:validate(<<"foo">>,
                              {string, #{values => [a, b]}}))].

validate_array_test_() ->
  [?_assertMatch({ok, _},
                 jsv:validate([], array)),
   ?_assertMatch({ok, _},
                 jsv:validate([1, 2, 3], array)),
   ?_assertMatch({ok, _},
                 jsv:validate([[], []], array)),
   ?_assertMatch({ok, _},
                 jsv:validate([1, 2, 3], {array, #{min_length => 3}})),
   ?_assertMatch({ok, _},
                 jsv:validate([1, 2, 3, 4], {array, #{min_length => 3}})),
   ?_assertMatch({error, _},
                 jsv:validate([], {array, #{min_length => 3}})),
   ?_assertMatch({error, _},
                 jsv:validate([1, 2], {array, #{min_length => 3}})),
   ?_assertMatch({ok, _},
                 jsv:validate([1, 2, 3], {array, #{max_length => 3}})),
   ?_assertMatch({ok, _},
                 jsv:validate([], {array, #{max_length => 3}})),
   ?_assertMatch({error, _},
                 jsv:validate([1, 2, 3, 4],
                              {array, #{max_length => 3}})),
   ?_assertMatch({error, _},
                 jsv:validate([1, 2, 4, 4, 5],
                              {array, #{unique_elements => true}})),
   ?_assertMatch({ok, _},
                 jsv:validate([1, 2, 3, 4, 5],
                              {array, #{unique_elements => true}})),
   ?_assertMatch({error, _},
                 jsv:validate([1, 2, 3, 4, 5],
                              {array, #{unique_elements => false}})),
   ?_assertMatch({ok, _},
                 jsv:validate([1, 2, 3, 4, 4],
                              {array, #{unique_elements => false}})),
   ?_assertMatch({ok, _},
                 jsv:validate([[<<"ab">>, true, [1]], [<<"ab">>, true, [2]]],
                              {array, #{unique_elements => true}})),
   ?_assertMatch({ok, _},
                 jsv:validate([[#{a => <<"ab">>}], [#{a => <<"ba">>}]],
                              {array, #{unique_elements => true}})),
   ?_assertMatch({error, _},
                 jsv:validate([[#{a => <<"ab">>}], [#{a => <<"ab">>}]],
                              {array, #{unique_elements => true}})),
   ?_assertMatch({ok, _},
                 jsv:validate([], {array, #{element => integer}})),
   ?_assertMatch({ok, _},
                 jsv:validate([1, 2, 3],
                              {array, #{element => integer}})),
   ?_assertMatch({error, _},
                 jsv:validate([true],
                              {array, #{element => integer}})),
   ?_assertMatch({error, _},
                 jsv:validate([1, 2, null],
                              {array, #{element => integer}})),
   ?_assertMatch({ok, _},
                 jsv:validate([[], [1, 2.5], [3.0]],
                              {array, #{element =>
                                          {array, #{element =>
                                                      number}}}})),
   ?_assertMatch({error, _},
                 jsv:validate([0, [1, 2.5], [3.0]],
                              {array, #{element =>
                                          {array, #{element =>
                                                      number}}}})),
   ?_assertMatch({ok, _},
                 jsv:validate([], {array, #{element =>
                                              {array, #{element =>
                                                          number}}}})),
   ?_assertMatch({ok, [{10, 20, 30}, {11, 0, 0}]},
                 jsv:validate([<<"10:20:30">>, <<"11:00:00">>],
                              {array, #{element => time}}))].

validate_object_test_() ->
  [?_assertEqual({ok, #{}},
                 jsv:validate(#{}, object)),
   ?_assertEqual({ok, #{<<"a">> => 1}},
                 jsv:validate(#{<<"a">> => 1}, object)),
   ?_assertEqual({ok, #{<<"a">> => 1, <<"b">> => 2}},
                 jsv:validate(#{<<"a">> => 1, <<"b">> => 2},
                              {object, #{min_size => 2}})),
   ?_assertEqual({ok, #{<<"a">> => 1, <<"b">> => 2, <<"c">> => 3}},
                 jsv:validate(#{<<"a">> => 1, <<"b">> => 2, <<"c">> => 3},
                              {object, #{min_size => 2}})),
   ?_assertMatch({error, _},
                 jsv:validate(#{},
                              {object, #{min_size => 2}})),
   ?_assertMatch({error, _},
                 jsv:validate(#{<<"a">> => 1},
                              {object, #{min_size => 2}})),
   ?_assertEqual({ok, #{}},
                 jsv:validate(#{}, {object, #{max_size => 2}})),
   ?_assertEqual({ok, #{<<"a">> => 1, <<"b">> => 2}},
                 jsv:validate(#{<<"a">> => 1, <<"b">> => 2},
                              {object, #{max_size => 2}})),
   ?_assertMatch({error, _},
                 jsv:validate(#{<<"a">> => 1, <<"b">> => 2, <<"c">> => 3},
                              {object, #{max_size => 2}})),
   ?_assertEqual({ok, #{<<"a">> => 1}},
                 jsv:validate(#{<<"a">> => 1}, {object, #{value => integer}})),
   ?_assertEqual({ok, #{}},
                 jsv:validate(#{}, {object, #{value => integer}})),
   ?_assertMatch({error, _},
                 jsv:validate(#{<<"a">> => true, <<"b">> => 42},
                              {object, #{value => integer}})),
   ?_assertEqual({ok, #{<<"a">> => 1, <<"b">> => 2}},
                 jsv:validate(#{<<"a">> => 1, <<"b">> => 2},
                              {object, #{required => [a, b]}})),
   ?_assertEqual({ok, #{<<"a">> => 1, <<"b">> => 2, <<"c">> => 3}},
                 jsv:validate(#{<<"a">> => 1, <<"b">> => 2, <<"c">> => 3},
                              {object, #{required => [a, b]}})),
   ?_assertMatch({error, _},
                 jsv:validate(#{<<"a">> => 1, <<"c">> => 3},
                              {object, #{required =>
                                           [a, b]}})),
   ?_assertMatch({error, _},
                 jsv:validate(#{<<"c">> => 3},
                              {object, #{required =>
                                           [a, b]}})),
   ?_assertEqual({ok, #{}},
                 jsv:validate(#{}, {object, #{required => []}})),
   ?_assertEqual({ok, #{a => 1, b => true}},
                 jsv:validate(#{<<"a">> => 1, <<"b">> => true},
                              {object, #{members =>
                                           #{a => integer,
                                             b => boolean}}})),
   ?_assertEqual({ok, #{a => 1}},
                 jsv:validate(#{<<"a">> => 1},
                              {object, #{members =>
                                           #{a => integer,
                                             b => boolean}}})),
   ?_assertEqual({ok, #{}},
                 jsv:validate(#{},
                              {object, #{members =>
                                           #{a => integer,
                                             b => boolean}}})),
   ?_assertMatch({error, _},
                 jsv:validate(#{<<"a">> => 1, <<"b">> => true},
                              {object, #{members =>
                                           #{a => integer,
                                             b => null}}})),
   ?_assertEqual({ok, #{a => 1, b => true}},
                 jsv:validate(#{<<"a">> => 1, <<"b">> => true},
                              {object, #{members =>
                                           #{a => integer,
                                             b => boolean},
                                         required =>
                                           [a, b]}})),
   ?_assertEqual({ok, #{a => {2020, 8, 1}}},
                 jsv:validate(#{<<"a">> => <<"2020-08-01">>},
                              {object, #{members =>
                                           #{a => date}}})),
   ?_assertMatch({error, _},
                 jsv:validate(#{<<"a">> => <<"2020-08-01">>,
                                <<"b">> => <<"2020-10-01">>},
                              {object, #{members =>
                                           #{a => date}}})),
   ?_assertMatch({error, _},
                 jsv:validate(#{<<"a">> => <<"2020-08-01">>,
                                <<"b">> => <<"2020-10-01">>},
                              {object, #{members =>
                                           #{a => date}}},
                             #{unknown_member_handling => error})),
   ?_assertEqual({ok, #{a => {2020, 8, 1}}},
                 jsv:validate(#{<<"a">> => <<"2020-08-01">>},
                              {object, #{members =>
                                           #{a => date}}},
                             #{unknown_member_handling => remove})),
   ?_assertEqual({ok, #{a => {2020, 8, 1}, <<"b">> => <<"2020-10-01">>}},
                 jsv:validate(#{<<"a">> => <<"2020-08-01">>,
                                <<"b">> => <<"2020-10-01">>},
                              {object, #{members =>
                                           #{a => date}}},
                             #{unknown_member_handling => keep})),
   ?_assertEqual({ok, #{<<"a">> => 1}},
                 jsv:validate(#{<<"a">> => 1, <<"b">> => null},
                              {object, #{value => integer}},
                              #{null_member_handling => remove})),
   ?_assertEqual({ok, #{<<"a">> => 1, <<"b">> => null}},
                 jsv:validate(#{<<"a">> => 1, <<"b">> => null},
                              {object, #{value => {one_of, [integer, null]}}},
                              #{null_member_handling => keep}))].

validate_uuid_test_() ->
  [?_assertEqual({ok, <<202,180,203,128,76,102,78,212,
                        178,72,123,82,146,81,48,241>>},
                 jsv:validate(<<"cab4cb80-4c66-4ed4-b248-7b52925130f1">>,
                              uuid)),
   ?_assertEqual({ok, <<202,180,203,128,76,102,78,212,
                        178,72,123,82,146,81,48,241>>},
                 jsv:validate(<<"CAB4CB80-4C66-4ED4-B248-7B52925130F1">>,
                              uuid)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"">>, uuid)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"foobar">>, uuid)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"xyb4cb80-4c66-4ed4-b248-7b52925130f1">>,
                              uuid)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"cab4cb80-4c66-4ed4-b248-7b52925130f1-12">>,
                              uuid))].

validate_ksuid_test_() ->
  [?_assertEqual({ok, <<"1l0UE6izCgIw533MOupkAowglGJ">>},
                 jsv:validate(<<"1l0UE6izCgIw533MOupkAowglGJ">>, ksuid)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"">>, ksuid)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"foobar">>, ksuid)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"1l0UE6izCgIw533MOupkAowglG=">>, ksuid))].

validate_uri_test_() ->
  [?_assertMatch({ok, _},
                 jsv:validate(<<"http://example.com">>, uri)),
   ?_assertMatch({ok, _},
                 jsv:validate(<<"/foo/bar">>, uri)),
   ?_assertMatch({ok, _},
                 jsv:validate(<<"//example.com?a=b#foo">>, uri)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"">>, uri))].

validate_email_address_test_() ->
  [?_assertMatch({ok, _},
                 jsv:validate(<<"foo@example.com">>, email_address)),
   ?_assertMatch({ok, _},
                 jsv:validate(<<"foo+test@example.com">>, email_address)),
   ?_assertMatch({ok, _},
                 jsv:validate(<<"foo+test@example.com.">>, email_address)),
   ?_assertMatch({ok, _},
                 jsv:validate(<<"foo@com">>, email_address)),
   ?_assertMatch({ok, _},
                 jsv:validate(<<"foo@com.">>, email_address)),
   ?_assertMatch({ok, _},
                 jsv:validate(<<"foo@com.">>, email_address)),
   ?_assertMatch({ok, _},
                 jsv:validate(<<"foo@192.0.2.1">>, email_address)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"foo">>, email_address)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"foo@">>, email_address)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"example.com">>, email_address)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"@example.com">>, email_address))].

validate_time_test_() ->
  [?_assertMatch({ok, {10, 20, 30}},
                 jsv:validate(<<"10:20:30">>, time)),
   ?_assertMatch({ok, {0, 0, 0}},
                 jsv:validate(<<"00:00:00">>, time)),
   ?_assertMatch({ok, {23, 59, 59}},
                 jsv:validate(<<"23:59:59">>, time)),
   ?_assertMatch({ok, {23, 59, 60}},
                 jsv:validate(<<"23:59:60">>, time)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"">>, time)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"10">>, time)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"10:20">>, time)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"10:20:3">>, time)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"1:20:30">>, time)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"102030">>, time)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"1a:20:30">>, time)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"10:-2:30">>, time)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"24:00:00">>, time)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"10:60:00">>, time)),
   ?_assertMatch({ok, {10, 20, 30}},
                 jsv:validate(<<"10:20:30">>,
                              {time, #{min => {10, 0, 0}}})),
   ?_assertMatch({ok, {10, 20, 30}},
                 jsv:validate(<<"10:20:30">>,
                              {time, #{min => {10, 20, 30}}})),
   ?_assertMatch({error, _},
                 jsv:validate(<<"10:20:30">>,
                              {time, #{min => {10, 20, 31}}})),
   ?_assertMatch({ok, {10, 20, 30}},
                 jsv:validate(<<"10:20:30">>,
                              {time, #{max => {11, 0, 0}}})),
   ?_assertMatch({ok, {11, 0, 0}},
                 jsv:validate(<<"11:00:00">>,
                              {time, #{max => {11, 0, 0}}})),
   ?_assertMatch({error, _},
                 jsv:validate(<<"11:00:01">>,
                              {time, #{max => {11, 0, 0}}}))].

validate_date_test_() ->
  [?_assertMatch({ok, {2010, 1, 1}},
                 jsv:validate(<<"2010-01-01">>, date)),
   ?_assertMatch({ok, {2010, 12, 31}},
                 jsv:validate(<<"2010-12-31">>, date)),
   ?_assertMatch({ok, {2012, 2, 29}},
                 jsv:validate(<<"2012-02-29">>, date)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"2013-02-29">>, date)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"2012-01-32">>, date)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"2012-13-01">>, date)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"">>, date)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"foo">>, date)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"2010">>, date)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"2010-01">>, date)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"2010-01-">>, date)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"-01-01">>, date)),
   ?_assertMatch({ok, {2010, 1, 1}},
                 jsv:validate(<<"2010-01-01">>,
                              {date, #{min => {2010, 1, 1}}})),
   ?_assertMatch({ok, {2010, 12, 31}},
                 jsv:validate(<<"2010-12-31">>,
                              {date, #{min => {2010, 1, 1}}})),
   ?_assertMatch({error, _},
                 jsv:validate(<<"2009-12-31">>,
                              {date, #{min => {2010, 1, 1}}})),
   ?_assertMatch({ok, {2010, 1, 1}},
                 jsv:validate(<<"2010-01-01">>,
                              {date, #{max => {2010, 1, 1}}})),
   ?_assertMatch({ok, {2009, 12, 31}},
                 jsv:validate(<<"2009-12-31">>,
                              {date, #{max => {2010, 1, 1}}})),
   ?_assertMatch({error, _},
                 jsv:validate(<<"2010-01-02">>,
                              {date, #{max => {2010, 1, 1}}}))].

validate_datetime_test_() ->
  [?_assertMatch({ok, {{2010, 1, 1}, {0, 0, 0}}},
                 jsv:validate(<<"2010-01-01T00:00:00Z">>, datetime)),
   ?_assertMatch({ok, {{2010, 12, 31}, {21, 0, 0}}},
                 jsv:validate(<<"2010-12-31T23:00:00+02:00">>, datetime)),
   ?_assertMatch({ok, {{2010, 2, 28}, {6, 46, 0}}},
                 jsv:validate(<<"2010-02-28t05:00:60-01:45">>, datetime)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"2010-01-01T00:00:00">>, datetime)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"00:00:00">>, datetime)),
   ?_assertMatch({error, _},
                 jsv:validate(<<"2010-01-01">>, datetime)),
   ?_assertMatch({ok, {{2010, 1, 1}, {12, 0, 0}}},
                 jsv:validate(<<"2010-01-01T12:00:00Z">>,
                              {datetime, #{min => {{2010, 1, 1},
                                                   {12, 0, 0}}}})),
   ?_assertMatch({error, _},
                 jsv:validate(<<"2010-01-01T12:00:00Z">>,
                              {datetime, #{min => {{2010, 1, 1},
                                                   {12, 0, 1}}}})),
   ?_assertMatch({error, _},
                 jsv:validate(<<"2010-01-01T12:00:00Z">>,
                              {datetime, #{min => {{2010, 1, 2},
                                                   {10, 0, 0}}}})),
   ?_assertMatch({ok, {{2010, 1, 1}, {17, 0, 0}}},
                 jsv:validate(<<"2010-01-01T11:00:00-06:00">>,
                              {datetime, #{min => {{2010, 1, 1},
                                                   {12, 0, 0}}}})),
   ?_assertMatch({error, _},
                 jsv:validate(<<"2010-01-01T11:59:59Z">>,
                              {datetime, #{min => {{2010, 1, 1},
                                                   {12, 0, 0}}}})),
   ?_assertMatch({error, _},
                 jsv:validate(<<"2010-01-01T13:00:00+04:00">>,
                              {datetime, #{min => {{2010, 1, 1},
                                                   {12, 0, 0}}}})),
   ?_assertMatch({ok, {{2010, 1, 1}, {12, 0, 0}}},
                 jsv:validate(<<"2010-01-01T12:00:00Z">>,
                              {datetime, #{max => {{2010, 1, 1},
                                                   {12, 0, 0}}}})),
   ?_assertMatch({ok, {{2010, 1, 1}, {11, 59, 59}}},
                 jsv:validate(<<"2010-01-01T11:59:59Z">>,
                              {datetime, #{max => {{2010, 1, 1},
                                                   {12, 0, 0}}}})),
   ?_assertMatch({ok, {{2009, 12, 31}, {13, 0, 0}}},
                 jsv:validate(<<"2009-12-31T13:00:00Z">>,
                              {datetime, #{max => {{2010, 1, 1},
                                                   {12, 0, 0}}}})),
   ?_assertMatch({error, _},
                 jsv:validate(<<"2010-01-01T12:00:01Z">>,
                              {datetime, #{max => {{2010, 1, 1},
                                                   {12, 0, 0}}}})),
   ?_assertMatch({error, _},
                 jsv:validate(<<"2010-01-02T12:00:00Z">>,
                              {datetime, #{max => {{2010, 1, 1},
                                                   {12, 0, 0}}}})),
   ?_assertMatch({error, _},
                 jsv:validate(<<"2010-01-01T11:00:00-03:00">>,
                              {datetime, #{max => {{2010, 1, 1},
                                                   {12, 0, 0}}}})),
   ?_assertMatch({ok, {{2010, 1, 1}, {11, 0, 0}}},
                 jsv:validate(<<"2010-01-01T13:00:00+02:00">>,
                              {datetime, #{max => {{2010, 1, 1},
                                                   {12, 0, 0}}}}))].

validate_one_of_test_() ->
  [?_assertError({invalid_definition, [invalid_empty_definition_list]},
                 jsv:validate(42, {one_of, []})),
   ?_assertEqual({ok, 42},
                jsv:validate(42, {one_of, [string, integer]})),
   ?_assertEqual({ok, <<"foo">>},
                 jsv:validate(<<"foo">>, {one_of, [string, integer]})),
   ?_assertMatch({error, [#{reason := invalid_type}]},
                 jsv:validate(true, {one_of, [string, integer]})),
   ?_assertEqual({ok, <<"2020-01-28">>},
                 jsv:validate(<<"2020-01-28">>, {one_of, [string, date]})),
   ?_assertEqual({ok, {2020,1,28}},
                 jsv:validate(<<"2020-01-28">>, {one_of, [date, string]}))].

validate_catalogs_test_() ->
  {setup,
   fun () ->
       Catalog = #{a => integer,
                   b => {ref, c},
                   c => integer,
                   d => {ref, z},
                   e => {array, #{element => {one_of, [null, {ref, f}]}}},
                   f => {object, #{value => {one_of, [null, {ref, e}]}}}},
       jsv_catalog_registry:start_link(),
       jsv:register_catalog(test, Catalog)
   end,
   fun (_) ->
       jsv:unregister_catalog(test),
       jsv_catalog_registry:stop()
   end,
   [?_assertError({invalid_definition, [{unknown_catalog, test2}]},
                  jsv:validate(42, {ref, test2, a})),
    ?_assertError({invalid_definition, [{unknown_definition, test, foo}]},
                  jsv:validate(42, {ref, test, foo})),
    ?_assertMatch({ok, _},
                  jsv:validate(42, {ref, test, a})),
    ?_assertMatch({error, _},
                  jsv:validate(<<"hello">>, {ref, test, a})),
    ?_assertError({invalid_definition, [{unknown_definition, test, z}]},
                  jsv:validate(42, {ref, test, d})),
    ?_assertMatch({ok, _},
                  jsv:validate(42, {ref, test, b})),
    ?_assertMatch({ok, _},
                  jsv:validate([null, #{a => [], b => null}],
                               {ref, test, e}))]}.

extra_validate_test_() ->
  ValidateOddInteger =
    fun (I) ->
        case I rem 2 of
          0 -> {ok, I};
          1 -> {error, {invalid_value, I, invalid_odd_integer,
                        "value is not an odd integer"}}
        end
    end,
  Def = {integer, #{}, #{validate => ValidateOddInteger}},
  [?_assertMatch({ok, 42},
                 jsv:validate(42, Def)),
   ?_assertMatch({error, [#{reason :=
                              {invalid_value, invalid_odd_integer, _}}]},
                 jsv:validate(1, Def))].

extra_validate_child_test_() ->
  Validate =
    fun (Value = #{type := Type, data := Data}) ->
        DataDef = case Type of
                    name -> {string, #{min_length => 1}};
                    score -> {integer, #{min => 0}}
                  end,
        case jsv:validate(Data, DataDef) of
          {ok, Data2} ->
            {ok, Value#{data => Data2}};
          {error, Errors} ->
            {error, {invalid_child, [<<"data">>], Errors}}
        end
    end,
  Def = {object,
         #{members =>
             #{type => {string, #{values => [name, score]}},
               data => any},
           required =>
             [type, data]},
         #{validate => Validate}},
  [?_assertEqual({ok, #{type => name, data => <<"Bob">>}},
                 jsv:validate(#{<<"type">> => <<"name">>,
                                <<"data">> => <<"Bob">>},
                              Def)),
   ?_assertEqual({ok, #{type => score, data => 42}},
                 jsv:validate(#{<<"type">> => <<"score">>,
                                <<"data">> => 42},
                              Def)),
   ?_assertMatch({error, [#{pointer := [<<"data">>],
                            reason := {invalid_type, string}}]},
                 jsv:validate(#{<<"type">> => <<"name">>,
                                <<"data">> => true},
                              Def)),
   ?_assertMatch({error, [#{pointer := [<<"data">>],
                            reason := {constraint_violation, string,
                                       {min_length, 1}}}]},
                 jsv:validate(#{<<"type">> => <<"name">>,
                                <<"data">> => <<>>},
                              Def)),
   ?_assertMatch({error, [#{pointer := [<<"data">>],
                            reason := {invalid_type, integer}}]},
                 jsv:validate(#{<<"type">> => <<"score">>,
                                <<"data">> => <<"foo">>},
                              Def)),
   ?_assertMatch({error, [#{pointer := [<<"data">>],
                            reason := {constraint_violation, integer,
                                       {min, 0}}}]},
                 jsv:validate(#{<<"type">> => <<"score">>,
                                <<"data">> => -1},
                              Def))].
