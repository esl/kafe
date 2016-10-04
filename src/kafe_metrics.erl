% @hidden
-module(kafe_metrics).

-export([
         init_consumer/1
         , delete_consumer/1
         , consumer_messages/2

         , init_consumer_partition/3
         , delete_consumer_partition/3
         , consumer_partition_messages/4
         , consumer_partition_duration/4
        ]).

init_consumer(Consumer) ->
  metrics:new(gauge, consumer_metric(Consumer, <<"messages.fetch">>)),
  metrics:new(counter, consumer_metric(Consumer, <<"messages">>)).

delete_consumer(Consumer) ->
  metrics:delete(consumer_metric(Consumer, <<"messages.fetch">>)),
  metrics:delete(consumer_metric(Consumer, <<"messages">>)).

consumer_messages(Consumer, NbMessages) ->
  metrics:update(consumer_metric(Consumer, <<"messages.fetch">>), NbMessages),
  metrics:update(consumer_metric(Consumer, <<"messages">>), {c, NbMessages}).

consumer_metric(Consumer, Ext) ->
  bucs:to_string(<<"kafe_consumer.",
                   (bucs:to_binary(Consumer))/binary,
                   ".", Ext/binary>>).

init_consumer_partition(Consumer, Topic, Partition) ->
  metrics:new(gauge, consumer_partition_metric(Consumer, Topic, Partition, <<"messages.fetch">>)),
  metrics:new(gauge, consumer_partition_metric(Consumer, Topic, Partition, <<"duration.fetch">>)),
  metrics:new(counter, consumer_partition_metric(Consumer, Topic, Partition, <<"messages">>)).

delete_consumer_partition(Consumer, Topic, Partition) ->
  metrics:delete(consumer_partition_metric(Consumer, Topic, Partition, <<"messages.fetch">>)),
  metrics:delete(consumer_partition_metric(Consumer, Topic, Partition, <<"duration.fetch">>)),
  metrics:delete(consumer_partition_metric(Consumer, Topic, Partition, <<"messages">>)).

consumer_partition_messages(Consumer, Topic, Partition, NbMessages) ->
  metrics:update(consumer_partition_metric(Consumer, Topic, Partition, <<"messages.fetch">>),
                 NbMessages),
  metrics:update(consumer_partition_metric(Consumer, Topic, Partition, <<"messages">>),
                 {c, NbMessages}).

consumer_partition_duration(Consumer, Topic, Partition, Duration) ->
  metrics:update(consumer_partition_metric(Consumer, Topic, Partition, <<"duration.fetch">>),
                 Duration).

consumer_partition_metric(Consumer, Topic, Partition, Ext) ->
  bucs:to_string(<<"kafe_consumer.",
                   (bucs:to_binary(Consumer))/binary,
                   ".", (bucs:to_binary(Topic))/binary,
                   ".", (bucs:to_binary(Partition))/binary,
                   ".", Ext/binary>>).
