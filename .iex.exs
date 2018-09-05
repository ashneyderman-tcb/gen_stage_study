alias GenStageStudy.EventsStream, as: E

one = fn() -> E.add_event(1) end
five = fn() -> E.add_events([1,2,3,4,5]) end