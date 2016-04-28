-module(kafe_protocol_produce_tests).

-include_lib("eunit/include/eunit.hrl").
-include("kafe_tests.hrl").

kafe_protocol_produce_test_() ->
  {setup, fun setup/0, fun teardown/1,
   [
    ?_test(t_request()),
    ?_test(t_response())
   ]
  }.

setup() ->
  ok.

teardown(_) ->
  ok.

t_request() ->
  ?assertEqual(#{api_version => 0,
                 packet => <<0,0,0,80,0,0,0,0,0,0,0,0,0,4,116,101,115,116,255,255,0,0,19,136,0,0,0,1,0,
                             5,116,111,112,105,99,0,0,0,1,0,0,0,0,0,0,0,37,0,0,0,0,0,0,0,0,0,0,0,25,86,
                             91,193,236,0,0,0,0,0,0,0,0,0,11,104,101,108,108,111,32,119,111,114,108,100>>,
                 state => ?REQ_STATE2(1, 0)},
               kafe_protocol_produce:request(<<"topic">>, <<"hello world">>, #{}, ?REQ_STATE2(0, 0))),
  ?assertEqual(#{api_version => 1,
                 packet => <<0,0,0,80,0,0,0,1,0,0,0,0,0,4,116,101,115,116,255,255,0,0,19,136,0,0,0,1,0,
                             5,116,111,112,105,99,0,0,0,1,0,0,0,0,0,0,0,37,0,0,0,0,0,0,0,0,0,0,0,25,201,
                             129,66,114,1,0,0,0,0,0,0,0,0,11,104,101,108,108,111,32,119,111,114,108,100>>,
                 state => ?REQ_STATE2(1, 1)},
               kafe_protocol_produce:request(<<"topic">>, <<"hello world">>, #{}, ?REQ_STATE2(0, 1))),
  ?assertEqual(#{api_version => 2,
                 packet => <<0,0,0,88,0,0,0,2,0,0,0,0,0,4,116,101,115,116,255,255,0,0,19,136,0,0,0,1,0,
                             5,116,111,112,105,99,0,0,0,1,0,0,0,0,0,0,0,45,0,0,0,0,0,0,0,0,0,0,0,33,251,
                             23,214,173,2,0,0,5,47,244,222,233,154,131,0,0,0,0,0,0,0,11,104,101,108,108,
                             111,32,119,111,114,108,100>>,
                 state => ?REQ_STATE2(1, 2)},
               kafe_protocol_produce:request(<<"topic">>, <<"hello world">>, #{timestamp => 1460103641930371}, ?REQ_STATE2(0, 2))).

t_response() ->
  ?assertEqual({ok,[#{name => <<"topic">>,
                      partitions => [#{error_code => none, offset => 5, partition => 0}]}]},
               kafe_protocol_produce:response(
                 <<0,0,0,1,0,5,116,111,112,105,99,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,
                   0,0,5>>, 0)).

