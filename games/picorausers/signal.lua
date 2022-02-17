signals = {}

function register(signal_name, callback)
  if not signals[signal_name] then signals[signal_name] = {} end
  add(signals[signal_name], callback)
end

function emit(signal_name, ...)
  if not signals[signal_name] then return end
  
  for i=1, #signals[signal_name] do
    signals[signal_name][i](...)
  end
end

function unregister(signal_name, callback)
  if not signals[signal_name] then return end

  for i=1, #signals[signal_name] do
    if signals[signal_name][i] == callback then deli(signals[signal_name], i) end
  end
end

function clear_signal(signal_name)
  signals[signal_name] = nil
end