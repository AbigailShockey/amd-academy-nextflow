ids = ['ERR908507', 'ERR908506', 'ERR908505']

queue_ch = channel.fromList(ids)
value_ch = channel.value(ids)
queue_ch.view()
value_ch.view()
