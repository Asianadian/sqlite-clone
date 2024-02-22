describe 'database' do
    def run_script(commands)
        raw_output = nil
        IO.popen("./a.out", "r+") do |pipe|
            commands.each do |command|
                pipe.puts command
            end

            pipe.close_write

            raw_output = pipe.gets(nil)
        end
        raw_output.split("\n")
    end

    it 'inserts and retrieves a row' do
        result = run_script([
            "INSERT 1 user1 person1@example.com",
            "SELECT",
            ".exit",
        ])
        expect(result).to match_array([
            "db > Execute success",
            "db > (1, user1, person1@example.com)",
            "Execute success",
            "db > ",
        ])
    end
end