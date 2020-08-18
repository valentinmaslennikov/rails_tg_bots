class PrisonerRepo
  class << self
    def find_by(**args)
      Prisoner.find_by(args.to_h)
    end
  end
end