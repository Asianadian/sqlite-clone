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

    it 'prints error message when table is full' do
        script = (1..1401).map do |i|
            "INSERT #{i} user#{i} #{i}@gmail.com"
        end
        script << ".exit"
        result = run_script(script)
        expect(result[-2]).to eq('db > Table is full')
    end

    it 'inserts max length strings' do
        long_user = "a"*32
        long_email = "a"*255
        result = run_script([
            "INSERT 1 #{long_user} #{long_email}",
            "SELECT",
            ".exit",
        ])
        expect(result).to match_array([
            "db > Execute success",
            "db > (1, #{long_user}, #{long_email})",
            "Execute success",
            "db > ",
        ])
    end

    it 'prints error message when string over max length' do
        long_user = "a"*33
        long_email = "a"*256
        result = run_script([
            "INSERT 1 #{long_user} #{long_email}",
            "SELECT",
            ".exit",
        ])
        expect(result).to match_array([
            "db > Execute success",
            "db > (1, #{long_user}, #{long_email})",
            "Execute success",
            "db > ",
        ])
    end
end