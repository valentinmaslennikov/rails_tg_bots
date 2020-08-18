class ChatRepo
  class << self
    def find_by(**args)
      Chat.find_by(args.to_h)
    end
  end
end